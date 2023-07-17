const express = require('express');
const router = express.Router();
const admin = require('../middlewares/admin');
const Product = require('../models/product');

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

module.exports = router;