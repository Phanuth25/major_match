import SelectModel from "../../model/majors/select_model.js";

export function select(req, res) {
  SelectModel.select((err, result) => {
    // Database error
    if (err) {
      console.error(err);

      return res.status(500).json({
        message: "Internal server error",
      });
    }

    // Email does not exist
    if (result.length === 0) {
      return res.status(404).json({
        message: "Major does not exist",
      });
    }

    // Select successful
    return res.status(200).json({
      message: "Select successful",
      majors: result,
    });
  });
}
