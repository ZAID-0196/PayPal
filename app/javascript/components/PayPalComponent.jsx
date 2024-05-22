// app/javascript/components/PayPalComponent.jsx
import React from "react";
import { PayPalScriptProvider, PayPalButtons } from "@paypal/react-paypal-js";

const PayPalComponent = () => {
  const initialOptions = {
    clientId: "YOUR_CLIENT_ID",
    // Add other options as needed
  };

  return (
    <div className="App">
      <PayPalScriptProvider options={initialOptions}>
        <PayPalButtons />
      </PayPalScriptProvider>
    </div>
  );
};

export default PayPalComponent;
