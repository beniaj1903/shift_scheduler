// IMPORTS

// external
import React, { useState, useEffect } from 'react'

// project
import './Apps.css';
import { apiGet } from './Utils/ApiFetch'

// END IMPORTS

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

  const [state, setState] = useState(initialState);

  // Did Mount
  useEffect(() => {
    const response = apiGet('shifts', {});
    if (response.status && response.status < 300) {
      setState({ viewState: response.viewState });
    } else {
      setError({ error: response.error });
    }
  }, []);

  useEffect(() => {
    
  }, []);

  return (

    <div className="App">

    </div>
  );
}

export default App;
