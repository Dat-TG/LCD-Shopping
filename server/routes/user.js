const express = require('express');
const router = express.Router();
const auth = require('../middlewares/auth');
const { Product } = require('../models/product');
const User = require('../models/user');
const Order = require('../models/order');

// Add product to cart
router.post('/add-to-cart', auth, async (req, res) => {
    try {
        const { id } = req.body;
        const product = await Product.findById(id);
        if (!product) {
          return res.status(400).json({msg: 'This product is now not available'});
        }
        let user = await User.findById(req.user);
        if (user.cart.length == 0) {
            user.cart.push({
                product,
                quantity: 1
            });
        } else {
            let isProductExist = false;
            for (let i = 0; i < user.cart.length; i++) {
                if (user.cart[i].product._id.equals(id)) {
                    user.cart[i].quantity++;
                    isProductExist = true;
                    break;
                }
            }
            if (!isProductExist) {
                user.cart.push({
                    product,
                    quantity: 1
                });
            }
        }
        user = await user.save();
        res.json(user);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

// Remove item from cart
router.delete('/remove-item/:id', auth, async (req, res) => {
    try {
        const id = req.params.id;
        const product = await Product.findById(id);
        let user = await User.findById(req.user);

        for (let i = 0; i < user.cart.length; i++) {
            if (user.cart[i].product._id.equals(id)) {
                user.cart.splice(i, 1);
                break;
            }
        }

        user = await user.save();
        res.json(user);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

// Update quantity of item
router.patch('/change-quantity-cart-item', auth, async (req, res) => {
    try {
        const {id, quantity} = req.body;
        const product = await Product.findById(id);
        let user = await User.findById(req.user);

        for (let i = 0; i < user.cart.length; i++) {
            if (user.cart[i].product._id.equals(id)) {
                user.cart[i].quantity=quantity;
                break;
            }
        }

        user = await user.save();
        res.json(user);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

// save user address
router.post("/save-user-address", auth, async (req, res) => {
    try {
      const { address } = req.body;
      let user = await User.findById(req.user);
      user.address = address;
      user = await user.save();
      res.json(user);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

// order products
router.post("/order", auth, async (req, res) => {
    try {
      const { cart, totalPrice, address } = req.body;
      let products=[];
      for (let i=0;i<cart.length;i++) {
        let product=await Product.findById(cart[i].product._id);
        if (product.quantity>=cart[i].quantity) {
            product.quantity-=cart[i].quantity;
            products.push({
                product: product,
                quantity: cart[i].quantity,
            });
            await product.save();
        } else {
            return res.status(400).json({msg: `Product ${product.name} is out of stock`})
        }
      }

      let user=await User.findById(req.user);
      user.cart=[];
      await user.save();

      let order=new Order({
        products,
        totalPrice,
        address,
        userId: req.user,
        orderedAt: new Date().getTime(),
      });

      order=await order.save();

      res.json(order);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });


// get all orders
router.get("/all-orders", auth, async (req, res) => {
    try {
      const orders=await Order.find({userId: req.user});
      res.json(orders);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

// Get orders by status
router.get("/get-orders", auth, async (req, res) => {
    try {
      const status=req.query.status;
      const userId=req.user;
      let orders=null;
      if (status>-1) orders = await Order.find({status: status, userId: userId});
      else orders=await Order.find({userId: userId});
      res.json(orders);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });



module.exports = router;