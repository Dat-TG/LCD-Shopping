// import packages
require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');

// import routers
const authRouter = require('./routes/auth');
const adminRouter=require('./routes/admin');

// connections
mongoose.connect(process.env.DB).then(() => {
    console.log('connected to database successfully');
}).catch((e) => {
    console.log('connect to database unsuccessfully, error: ', e);
});

// init
const app = express();
app.use(express.json());
const PORT = 3000;

// middlewares
// CLIENT --> middleware --> SERVER --> CLIENT
app.use('/user', authRouter);
app.use('/admin', adminRouter);

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server is running at port ${PORT}`);
})