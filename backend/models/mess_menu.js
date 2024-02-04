const mongoose = require('mongoose');

const messMenuSchema = new mongoose.Schema({
    id: {
        type: String,
        required: true
    },
    kitchenName: {
        type: String,
        required: true
    },
    messMenu: {
        type: Map,
        of: {
            type: Map,
            of: [String]
        },
        required: true
    }
});

const MessMenu = mongoose.model('MessMenu', messMenuSchema);

module.exports = MessMenu;
