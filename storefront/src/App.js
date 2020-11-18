import React from 'react';
import './App.css';
import { v4 as uuidv4 } from 'uuid';
import dotenv from 'dotenv';

class App extends React.Component {
  constructor() {
    super();
    this.state = {
      activeBackend: false,
      loading: true,
      quote: "There is no quote yet!",
      citation: "Your computer",
      responseLatency: undefined
    };

    // Set unique session identifier to identify user.
    sessionStorage.getItem('uuid') ?? sessionStorage.setItem('uuid', uuidv4());

  }

  componentDidMount() {
    this.getQuote();
  }

  getQuote(onLoad=false) {
    const startTime = new Date();
    this.setState({
      loading: true
    });
    const backend = (!process.env.NODE_ENV || process.env.NODE_ENV === 'development') ? "localhost" : process.env.REACT_APP_BACKEND_URL;
    const url = 'http://'+backend+':8080';
    fetch(url+'/quotes', {
        method: 'POST',
        mode: 'cors',
        headers: {
          'Access-Control-Allow-Origin':url
        },
        credentials: 'include',
        body: JSON.stringify({
          uuid : sessionStorage.getItem('uuid')
        })
      }
    )
      .then(res => res.json())
      .then(
        (response) => {
          const finishTime = new Date();
          this.setState({
            quote: response.quote,
            citation: response.citation,
            activeBackend: true,
            responseLatency: finishTime.getTime()-startTime.getTime() + "ms",
            loading: false
          });
        },
        (error) => {  
            this.setState({
              activeBackend: false,
              loading:false
            })
        }
      )
  }

  render() {
    let indicator;
    if (this.state.activeBackend) {
      indicator =  <div className="latencyIndicator">Stack responded in: {this.state.responseLatency}</div>
    }
    else if (this.state.loading) {
      indicator = <div className="latencyIndicator">Loading...</div>
    }
    else {
      indicator = <div className="latencyIndicator error">Unable to get your quotes due to a connection error.</div>
    }

    return(
      <section className="App">
        <blockquote>"{(this.state.loading) ? "Loading.." : this.state.quote}"</blockquote>
        <cite>&mdash; {(this.state.loading) ? "Loading.." : this.state.citation}</cite>
        <button onClick={() => this.getQuote()}>I need another one</button>
        {indicator}
      </section>
    )
  }
}

export default App;
