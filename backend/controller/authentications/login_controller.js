import LoginModel from "../../model/authentications/login_model.js";

export function login(req, res) {
  const { email, password } = req.body;

  LoginModel.login(email, (err, result) => {
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
        message: "Email does not exist",
      });
    }

    // Get the user returned from database
    const user = result[0];

    // Check password
    if (user.password !== password) {
      return res.status(401).json({
        message: "Incorrect password",
      });
    }

    // Login successful
    return res.status(200).json({
      message: "Login successful",
      user: user.id,
    });
  });
}
