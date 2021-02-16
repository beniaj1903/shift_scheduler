// IMPORTS

// external
import React, { useState, useEffect } from 'react'

// project
import './Apps.css';
import { apiGet } from './Utils/ApiFetch'

// END IMPORTS

const hostUrl = process.env

/*

  name: App

  Main container of the MVP, contents the state management and the inner components

*/

const App = () => {
  // Init
  const initialState = {
    viewState: {
      employees: [],
      shifts: [],
      services: [],
      weeks: [],
    },
    controls: {
      weekId: '',
      serviceId: '',
      shiftId: '',
    }
  };

  const [state, setstate] = useState(initialState);
  const [response, setResponse] = useState({});

  // Did Mount
  useEffect(() => {
    setResponse(apiGet(hostUrl, {}))
  }, []);

  useEffect(() => {
    
  }, []);

  return (

    <div className="App">

    </div>
  );
}

export default App;
