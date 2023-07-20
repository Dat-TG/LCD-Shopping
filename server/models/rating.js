const mongoose = require('mongoose');
const ratingSchema = mongoose.Schema({
    userId: {
        type: String,
        require: true
    },
    rating: {
        type: Number,
        require: true
    }

})

// const Rating = mongoose.model('Rating', ratingSchema);
module.exports = ratingSchema;