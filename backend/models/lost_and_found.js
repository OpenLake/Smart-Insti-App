import mongoose from 'mongoose';

const lostAndFoundItemSchema = new mongoose.Schema({
    userId: {
        type: String,
        required: true
    },
    name: {
        type: String,
        required: true
    },
    lastSeenLocation: {
        type: String,
    },
    imagePath: {
        type: String,
    },
    description: {
        type: String,
        required: true
    },
    contactNumber: {
        type: String,
        required: true
    },
    isLost: {
        type: Boolean,
        required: true
    }
});

const LostAndFoundItem = mongoose.model('LostAndFoundItem', lostAndFoundItemSchema);

export default LostAndFoundItem;