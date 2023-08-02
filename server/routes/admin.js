const express = require('express');
const router = express.Router();
const admin = require('../middlewares/admin');
const { Product } = require('../models/product');
const Order = require('../models/order');

// Add product
router.post('/add-product', admin, async (req, res) => {
  try {
    const { name, description, price, quantity, category, images } = req.body;
    let product = new Product({
      name, description, price, quantity, category, images
    })
    product = await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
})

// Edit product
router.patch('/edit-product', admin, async (req, res) => {
  try {
    const data = req.body;
    let product = await Product.findById(data.id);
    if (!product) {
      return res.status(400).json({msg: 'Product not found'});
    }
    product.name = data.name;
    product.quantity=data.quantity;
    product.price=data.price;
    product.images=data.images;
    product.description=data.description;
    product.category=data.category;
    product=await product.save();
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
})

// Get all products
router.get('/get-products', admin, async (req, res) => {
  try {
    const products = await Product.find({});
    res.json(products);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
})

// Delete products
router.delete('/product/:id', admin, async (req, res) => {
  try {
    const id = req.params.id;
    const product = await Product.findByIdAndDelete(id);
    res.json(product);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
})

// Get orders
router.get("/get-orders", admin, async (req, res) => {
  try {
    const status = req.query.status;
    let orders = null;
    if (status > -1) orders = await Order.find({ status: status });
    else orders = await Order.find({});
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Change order status
router.patch("/change-order-status", admin, async (req, res) => {
  try {
    const { id, status } = req.body;
    let order = await Order.findById(id);
    order.status = status;
    order = await order.save();
    res.json(order);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

router.get("/analytics", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    let totalEarnings = 0.0;
    // CATEGORY WISE ORDER FETCHING
    let mobileEarnings = 0.0;
    let essentialEarnings = 0.0;
    let applianceEarnings = 0.0;
    let booksEarnings = 0.0;
    let fashionEarnings = 0.0;

    for (let i = 0; i < orders.length; i++) {
      totalEarnings += orders[i].totalPrice;
      for (let j = 0; j < orders[i].products.length; j++) {
        let category = orders[i].products[j].product.category;
        if (category == "Mobiles") {
          mobileEarnings += orders[i].products[j].product.price * orders[i].products[j].quantity;
        }
        else if (category == "Essentials") {
          essentialEarnings += orders[i].products[j].product.price * orders[i].products[j].quantity;
        }
        else if (category == "Appliances") {
          applianceEarnings += orders[i].products[j].product.price * orders[i].products[j].quantity;
        }
        else if (category == "Books") {
          booksEarnings += orders[i].products[j].product.price * orders[i].products[j].quantity;
        }
        else if (category == "Fashion") {
          fashionEarnings += orders[i].products[j].product.price * orders[i].products[j].quantity;
        }
      }
    }

    let earnings = {
      totalEarnings,
      mobileEarnings,
      essentialEarnings,
      applianceEarnings,
      booksEarnings,
      fashionEarnings,
    };

    res.json(earnings);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


module.exports = router;