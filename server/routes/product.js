const express = require('express');
const router = express.Router();
const Product = require('../models/product');
const auth = require('../middlewares/auth');

// Get all products of a category
// /get-category?category=categoryName
router.get('/get', auth, async (req, res) => {
    try {
        const products = (req.query.category)
            ?
            await Product.find({
                category: req.query.category
            })
            :
            await Product.find({
                name: { $regex: req.query.searchQuery, $options: "i" },
            });
        res.json(products);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

module.exports = router;