const jwt=require('jsonwebtoken');
const auth=async(req,res,next)=>{
    try {
        const token=req.header('x-auth-token');
        if (!token) {
            return res.status(401).json({msg: 'No auth token, access denied'});
        }
        const isValid=jwt.verify(token, 'secret');
        if (!isValid) {
            return res.status(401).json({msg: 'Token verification failed, access denied'});
        }
        req.user=isValid.id;
        req.token=token;
        next(); 
    } catch (e) {
        res.status(500).json({error: e.message});
    }
}

module.exports=auth;