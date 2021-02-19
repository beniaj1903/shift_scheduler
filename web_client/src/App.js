// IMPORTS

// external
import React, { useState, useEffect } from 'react'
import {
  Grid,
  NativeSelect,
  Button,
  Paper
} from "@material-ui/core";

// project
// import './Apps.css';
import { apiGet, apiPost } from './Utils/ApiFetch'
import DailyBox from "./components/DailyBox";
import ManageInfoForm from "./components/ManageInfoForm";
import { getDateFromYearWeekDay } from './Utils/DateHelper'
// END IMPORTS

/*

  name: App

  Main container of the MVP, contents the state management and the inner components

*/

function getOptions(options) {
  return options.map(option => <option key={option.id} value={option.id}>{option.name}</option>)
}

const App = () => {

  // Init
  const initialState = {
    viewState: {
      shift_availabilities: [],
      employees: [],
      shifts: [],
      services: [],
      weeks: [],
    },
    controls: {
      weekId: '',
      serviceId: '',
      shiftId: '',
      checkboxMode: false,
      availabilities: []
    }
  };

  const [state, setState] = useState(initialState);
  const [error, setError] = useState('');

  const {
    availabilities,
    checkboxMode,
    serviceId,
    weekId,
    shiftId
  } = state.controls;
  const {
    shift_availabilities,
    services,
    shifts,
    weeks,
  } = state.viewState;

  function handleEmployeeCheckboxChange(employeeId, shiftIds, checked) {
    const newEmployeeShiftAvailabilities = shiftIds.map(id => ({ employee_id: employeeId, shift_id: id }));
    const newAvailabilities = checked ?
    [...state.controls.availabilities, ...newEmployeeShiftAvailabilities] :
    state.controls.availabilities.filter(sa => !(sa.employee_id === employeeId && shiftIds.includes(sa.shift_id)));
    setState({
      ...state,
      controls: {
        ...state.controls,
        availabilities: newAvailabilities,
      }
    });
  }
  function handleCheckboxChange(employeeId, rowId, checked) {
    const newAvailabilities = checked ?
      [...state.controls.availabilities, { employee_id: employeeId, shift_id: rowId }] :
      state.controls.availabilities.filter(sa => !(sa.employee_id === employeeId && sa.shift_id === rowId));
    setState({
      ...state,
      controls: {
        ...state.controls,
        availabilities: newAvailabilities,
      }
    });
  }

  const handleControlsChange = (event) => {
    const name = event.target.name;
    console.log('name', name)
    console.log('name', event)
    setState({
      ...state,
      controls: {
        ...state.controls,
        [name]: event.target.value,
      }
    });
  };

  const handleModeChange = async () => {
    let error = '';
    if (checkboxMode) {
      let response = await apiPost(`shifts/availabilities`, { body: { sas: availabilities } });
      const shift_availabilities = Object.values(response.viewState.shift_availabilities)
      if (response.status && response.status < 300 && shift_availabilities.length > 0) {
        // response = await apiPost(`shifts/distribuite`, { body:  });
        // if (response.status && response.status < 300) {
        // } else {
        //   setError({ error: response.error });
        // }
        console.log('response', response)
      } else {
        error = response.error || response.message;
        setError({ error: response.error });
      }
    } else {

    }
    console.log('error', error)
    if (!(error.length > 0)) {
      setState({ ...state, controls: { ...state.controls, checkboxMode: !checkboxMode } });
    }
  };
  // Did Mount
  useEffect(async () => {
    const response = await apiGet(`shifts`, {}, {});
    if (response.status && response.status < 300) {
      setState({ ...state, viewState: response.viewState });
    } else {
      setError({ error: response.error });
    }
  }, []);

  useEffect(async () => {
    const controls = {
      serviceId,
      weekId,
    };
    const response = await apiGet('shifts', controls, {});
    if (response.status && response.status < 300) {
      setState({ ...state, viewState: response.viewState });
    } else {
      setError({ error: response.error });
    }
  }, [serviceId, weekId]);
console.log('availabilities', availabilities)
  useEffect(() => {
    setState({ ...state, controls: { ...state.controls, availabilities: Object.values(shift_availabilities) } });
  }, [shift_availabilities]);

  const weekOptions = getOptions(Object.values(weeks).map(week => ({ ...week, name: `Semana ${week.number} del ${week.year}` })));
  const serviceOptions = getOptions(Object.values(services));
  const employees = Object.values(state.viewState.employees);
  const days = Object.values(shifts)
    .map(shift => {
      const employee = employees[shift.employee_id] ? employees[shift.employee_id].name : '';
      const week = weeks[shift.week_id];
      return ({
        ...shift,
        employee: employee,
        week: week.number,
        year: week.year,
      });
    })
    .reduce((obj, shift) => {
      const auxArray = Boolean(obj[shift.day]) ? [...obj[shift.day], shift] : [shift];
      return ({
        ...obj,
        [shift.day]: auxArray,
      })
    }, {});

  return (
    <Paper>
      <Grid container>
        <Grid item xs={3}>
          <NativeSelect
            onChange={(e) => handleControlsChange(e)}
            name="serviceId"
            label="Servicio"
            value={serviceId}
          >
            {serviceOptions}
          </NativeSelect>
        </Grid>
        <Grid item xs={3}>
          <NativeSelect
            onChange={(e) => handleControlsChange(e)}
            name="weekId"
            label="Semana"
            value={weekId}
          >
            {weekOptions}
          </NativeSelect>
        </Grid>
        <Grid item xs={3}>
          <Button
            name="checkBoxMode"
            // onClick={() => setState({ ...state, controls: { ...state.controls, checkboxMode: !checkboxMode } })}
            onClick={handleModeChange}
          >
            Editar disponibilidad
            </Button>
        </Grid>
      </Grid>
      <Grid container>
        {Object.entries(days).map((entrie) => {
          const [day, value] = entrie;
          const formatedDay = getDateFromYearWeekDay(day, value[0].week, value[0].year).toDateString()
          const shiftIds = value.map((row) => row.id);
          return <Grid key={day} item xs={3}>
            <DailyBox
              rows={value}
              day={formatedDay}
              employees={employees}
              checkboxMode={checkboxMode}
              availabilities={availabilities.filter(sa => shiftIds.includes(sa.shift_id))}
              shiftIds={shiftIds}
              handleCheckboxChange={handleCheckboxChange}
              handleEmployeeCheckboxChange={handleEmployeeCheckboxChange}
            />
          </Grid>
        })}
      </Grid>
    </Paper>
  );
}

export default App;
