const jwt=require('jsonwebtoken');
const User = require('../models/user');
const admin=async(req,res,next)=>{
    try {
        const token=req.header('x-auth-token');
        if (!token) {
            return res.status(401).json({msg: 'No auth token, access denied'});
        }
        const isValid=jwt.verify(token, 'secret');
        if (!isValid) {
            return res.status(401).json({msg: 'Token verification failed, access denied'});
        }
        const user=await User.findById(isValid.id);
        if (user.type!='admin') {
            return res.status(401).json({msg: 'You are not an admin, access denied'});
        }
        req.user=isValid.id;
        req.token=token;
        next(); 
    } catch (e) {
        res.status(500).json({error: e.message});
    }
}

module.exports=admin;