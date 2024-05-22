// app/javascript/packs/paypal.js
import React from "react";
import ReactDOM from "react-dom";
import PayPalComponent from "../components/PayPalComponent";

document.addEventListener("DOMContentLoaded", () => {
  const container = document.getElementById("paypal-container");
  if (container) {
    ReactDOM.render(<PayPalComponent />, container);
  }
});
