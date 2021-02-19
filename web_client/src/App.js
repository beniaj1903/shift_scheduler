// IMPORTS

// external
import React, { useState, useEffect } from 'react'

// project
// import './Apps.css';
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
  const [error, setError] = useState('');

  // Did Mount
  useEffect(async () => {
    const response = await apiGet('shifts', {});
    console.log("response", response)
    if (response.status && response.status < 300) {
      console.log('response.viewState', response.viewState)
      setState({ viewState: response.viewState });
    } else {
      setError({ error: response.error });
    }
  }, []);

  useEffect(() => {
    
  }, []);
  console.log("state", state)
  return (

    <div>

    </div>
  );
}

export default App;
