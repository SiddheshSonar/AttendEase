import React from "react";
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import { BrowserRouter as Router, Route} from 'react-router-dom';
import PageRoute from "./helper/Route";
import "./App.css"

function App() {
  return (
    <div>
      <Router>
        <PageRoute />
      </Router>
    </div>
  )
}

export default App;