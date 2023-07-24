const express = require('express');
const router = express.Router();
const auth = require('../middlewares/auth');
const {Product} = require('../models/product');
const User = require('../models/user');

// Add product to cart
router.post('/add-to-cart', auth, async (req, res) => {
    try {
        const {id}=req.body;
        const product=await Product.findById(id);
        let user=await User.findById(req.user);
        if (user.cart.length==0) {
            user.cart.push({
                product,
                quantity: 1
            });
        } else {
            let isProductExist=false;
            for (let i=0;i<user.cart.length;i++) {
                if (user.cart[i].product._id.equals(id)) {
                    user.cart[i].quantity++;
                    isProductExist=true;
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
        user=await user.save();
        res.json(user);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

module.exports = router;