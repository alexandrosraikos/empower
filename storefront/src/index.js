import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import * as serviceWorker from './serviceWorker';

ReactDOM.render(
  <React.StrictMode>
    <header><a href="/"><h1>Empower</h1></a></header>
    <App />
    <footer>Made by <a href="https://www.araikos.gr/" target="blank">A. Raikos</a> in <a href="http://www.kep.unipi.gr" target="blank">UPRC</a>.</footer>
  </React.StrictMode>,
  document.getElementById('root')
);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
