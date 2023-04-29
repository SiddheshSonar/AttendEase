import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'
import { ToastContainer } from 'react-toastify';

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
          <ToastContainer
      limit={1}
position="top-center"
autoClose={5000}
hideProgressBar={false}
newestOnTop={false}
closeOnClick
rtl={false}
pauseOnFocusLoss
draggable
pauseOnHover
theme="dark"
/>
    <App />
  </React.StrictMode>,
)
