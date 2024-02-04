
const mongoose = require('mongoose');

const roomSchema = new mongoose.Schema({
    id: {
        type: String,
        required: true,
    },
    name: {
        type: String,
        required: true,
    },
    vacant: {
        type: Boolean,
        default: true,
    },
    occupantId: {
        type: String,
        default: null,
    },
});

const Room = mongoose.model('Room', roomSchema);

module.exports = Room;

