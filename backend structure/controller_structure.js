// where models are imported and used to create controllers for the application
import productModel from '../model/productModel.js';

export function selectById(req, res) {
    const id = req.params.id;
    productModel.selectById(id, (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        if (result.length === 0) return res.status(404).json({ message: "Product not found" });
        const data = result[0];
        res.status(200).json({
            success: true,
            message: "Product loaded",
            data: data,
        });
    });
}