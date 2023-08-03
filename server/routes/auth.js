const express = require('express');
const User = require('../models/user');
const router = express.Router();
const bcrypt = require('bcrypt');
const saltRounds = 10;
const jwt = require('jsonwebtoken');
const auth = require('../middlewares/auth');
// Sign Up
router.post('/signup', async (req, res) => {
    try {
        const { name, email, password } = req.body;
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ msg: 'This email was already used' });
        }
        const hashedPassword = await bcrypt.hash(password, saltRounds);
        let user = new User({
            email,
            password: hashedPassword,
            name
        });
        user = await user.save();
        res.json(user);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

// Sign In
router.post('/signin', async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(400).json({ msg: 'This account does not exist' });
        }
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ msg: 'Incorrect password' });
        }
        const token = jwt.sign({ id: user._id }, 'secret');
        res.json({ token, ...user._doc });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

// Check token
router.post('/tokenIsValid', async (req, res) => {
    try {
        const token = req.header('x-auth-token');
        if (!token) return res.json(false);
        const isValid = jwt.verify(token, 'secret');
        if (!isValid) return res.json(false);
        const user = await User.findById(isValid.id);
        if (!user) return res.json(false);
        res.json(true);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

// Edit Information
router.patch('/edit-information', auth, async (req, res) => {
    try {
        const { name, email, address, avatar } = req.body;
        let user = await User.findById(req.user);
        if (!user) {
            return res.status(400).json({'msg': 'User not found'});
        }
        user.name=name;
        user.email=email;
        user.address=address;
        user.avatar=avatar;
        user = await user.save();
        const token = jwt.sign({ id: user._id }, 'secret');
        res.json({token, ...user._doc});
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

// Get user data
router.get('/', auth, async (req, res) => {
    try {
        const user = await User.findById(req.user);
        res.json({ ...user._doc, token: req.token });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
})

module.exports = router;