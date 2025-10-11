import mongoose from "mongoose";
import { type } from "os";

const FoodSchema = new mongoose.Schema(
    {
        name: {
            type: String,
            required: true,
            trim: true,
        },
        category: {
            type: String,
            required: true,
            trim: true,
        },
        imageUrl: {
            type: String, //url
            required: true
        },
        tags: {
            type: [String],
            default: [],
            index: true,
        },
        createdAt: {
            type:Date,
            default: Date.now,
        },
    },
    {
        timestamps: true,
    }
);

FoodSchema.index({
    name: "text",
    category: "text",
    tags: "text",
});

const Food = mongoose.model("Food", FoodSchema);
export default Food;