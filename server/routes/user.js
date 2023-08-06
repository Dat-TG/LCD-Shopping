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
      const { cart, totalPrice, address, isCheck } = req.body;
      let products=[];
      let newCart=[];
      for (let i=0;i<cart.length;i++) {
        if (isCheck[i]==false) {
          newCart.push(cart[i]);
        }
      }
      for (let i=0;i<cart.length;i++) {
        if (isCheck[i]==false) continue;
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
      user.cart=newCart;
      await user.save();

      let order=new Order({
        products,
        totalPrice,
        address,
        userId: req.user,
        orderedAt: new Date().getTime(),
      });

      order=await order.save();

      res.json(newCart);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });


// buy now
router.post("/buy-now", auth, async (req, res) => {
  try {
    const { totalPrice, address, productId, quantity } = req.body;
    let dbProduct=await Product.findById(productId);
    if (!dbProduct) {
      return res.status(400).json({msg: `Product ${dbProduct.name}  not found`});
    }

    if (dbProduct.quantity>=quantity) {
      dbProduct.quantity-=quantity;
      dbProduct=await dbProduct.save();
    } else {
      return res.status(400).json({msg: `Product ${dbProduct.name} does not have enough quantity`});
    }

    let products=[];
    products.push({
      product: dbProduct,
      quantity: quantity
    });

    let order=new Order({
      products,
      totalPrice,
      address,
      userId: req.user,
      orderedAt: new Date().getTime(),
    });

    order=await order.save();

    res.json(dbProduct);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


// get all orders
router.get("/all-orders", auth, async (req, res) => {
    try {
      const orders=await Order.find({userId: req.user}).sort({orderedAt: -1});
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
      if (status>-1) orders = await Order.find({status: status, userId: userId}).sort({orderedAt: -1});
      else orders=await Order.find({userId: userId}).sort({orderedAt: -1});
      res.json(orders);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

// Add product to wishList
router.post('/add-to-wishList', auth, async (req, res) => {
  try {
      const { id } = req.body;
      const product = await Product.findById(id);
      if (!product) {
        return res.status(400).json({msg: 'This product is now not available'});
      }
      let user = await User.findById(req.user);
      if (user.wishList.length == 0) {
          user.wishList.push(id);
      } else {
          let isProductExist = false;
          for (let i = 0; i < user.wishList.length; i++) {
              if (user.wishList[i]==id) {
                  isProductExist = true;
                  user.wishList.splice(i, 1);
                  break;
              }
          }
          if (!isProductExist) {
              user.wishList.push(id);
          } 
      }
      user = await user.save();
      res.json(user);

  } catch (e) {
      res.status(500).json({ error: e.message });
  }
})



module.exports = router;