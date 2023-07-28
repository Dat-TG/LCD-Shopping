const express = require('express');
const router = express.Router();
const admin = require('../middlewares/admin');
const {Product} = require('../models/product');
const Order=require('../models/order');

// Add product
router.post('/add-product', admin, async (req, res) => {
    try {
        const { name, description, price, quantity, category, images } = req.body;
        let product = new Product({
            name, description, price, quantity, category, images
        })
        product=await product.save();
        res.json(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

// Get all products
router.get('/get-products', admin, async(req, res)=>{
    try {
        const products=await Product.find({});
        res.json(products);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

// Delete products
router.delete('/product/:id', admin, async(req, res)=>{
    try {
        const id=req.params.id;
        const product=await Product.findByIdAndDelete(id);
        res.json(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

// Get orders
router.get("/get-orders", admin, async (req, res) => {
    try {
      const status=req.query.status;
      let orders=null;
      if (status>-1) orders = await Order.find({status: status});
      else orders=await Order.find({});
      res.json(orders);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });
  

module.exports = router;