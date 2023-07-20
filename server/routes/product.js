const express = require('express');
const router = express.Router();
const Product = require('../models/product');
const auth = require('../middlewares/auth');

// Get all products of a category
// /get?category=categoryName
// Get products by search query
// /get?searchQuery=searchQuery
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

// Rate a product
router.post('/rating', auth, async (req, res) => {
    try {
        const {id, rating}=req.body;
        let product=await Product.findById(id);
        for (let i=0;i<product.ratings.length;i++) {
            if (product.ratings[i].userId==req.user) {
                product.ratings.splice(i, 1);
                break;
            }
        }
        const ratingSchema={
            userId: req.user,
            rating
        }
        product.ratings.push(ratingSchema);
        product=await product.save();
        res.json(product);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

module.exports = router;