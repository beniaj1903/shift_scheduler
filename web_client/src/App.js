// IMPORTS

// external
import React, { useState, useEffect } from 'react'
import {
  Grid,
  NativeSelect,
  TableCell,
  Button,
  Paper
} from "@material-ui/core";

// project
import './App.css';
import { apiGet, apiPost } from './Utils/ApiFetch'
import DailyBox from "./components/DailyBox";
import ManageInfoForm from "./components/ManageInfoForm";
import { getDateFromYearWeekDay } from './Utils/DateHelper'
import { employeeColors } from "./Utils/Colors";
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
    const controlsAvailabilities = state.controls.availabilities.filter(sa => !(sa.employee_id === employeeId && shiftIds.includes(sa.shift_id)));
    const newAvailabilities = checked ?
      [...controlsAvailabilities, ...newEmployeeShiftAvailabilities] :
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
      let response = await apiPost(`shifts/availabilities`, { body: { sas: availabilities, service_id: serviceId, week_id: weekId } });
      const shift_availabilities = Object.values(response.viewState.shift_availabilities).sort((a, b) => a.employee_id < b.employee_id);
      const shift_ids = shift_availabilities.map(sa => sa.shift_id);
      const employee_ids = shift_availabilities.map(sa => sa.employee_id);

      if (response.status && response.status < 300 && shift_availabilities.length > 0) {
        response = await apiPost(`shifts/distribute`, { body: { shift_ids, employee_ids } });
        if (response.status && response.status < 300) {
          setState({
            ...state,
            viewState: {
              ...state.viewState,
              shifts: response.viewState.shifts,
            },
            controls: {
              ...state.controls,
              checkboxMode: !checkboxMode
            }
          });
        } else {
          setError({ error: response.error });
        }
      } else {
        error = response.error || response.message;
        setError({ error: response.error });
      }
    } else {
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

  useEffect(() => {
    setState({ ...state, controls: { ...state.controls, availabilities: Object.values(shift_availabilities) } });
  }, [shift_availabilities]);

  console.log('state.viewState', state.viewState)

  const weekOptions = getOptions(Object.values(weeks).map(week => ({ ...week, name: `Semana ${week.number} del ${week.year}` })));
  const serviceOptions = getOptions(Object.values(services));
  const employees = Object.values(state.viewState.employees);
  const employeesShiftCount = Object.values(shifts).reduce((obj, shift) => ({ ...obj, [shift.employee_id ? shift.employee_id : 0]: obj[shift.employee_id ? shift.employee_id : 0] ? obj[shift.employee_id ? shift.employee_id : 0] + 1 : 1 }), {});
  const days = Object.values(shifts)
    .map(shift => {
      const employee = state.viewState.employees[shift.employee_id] ? state.viewState.employees[shift.employee_id].name : '';
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
      <Grid container spacing={3} className="App-header" >
        <Grid item xs={2} />
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
        <Grid item xs={2}>
          <Button
            name="checkBoxMode"
            onClick={handleModeChange}
          >
            {Boolean(checkboxMode) ?  'Distribuir' : 'Disponibilidades'}
            </Button>
        </Grid>
        <Grid item xs={2} />
      </Grid>
      <Grid container className="App-body" >
        <Grid container style={{ maxHeight: 10 }}>
          {!checkboxMode && [ ...employees, { id: 0, name: "Sin asignar" } ].map(employee => <Grid item xs={3} align="center" key={employee.id} style={{ backgroundColor: employeeColors(employees, employee.id) }}>
            {`${employee.name}: ${employeesShiftCount[employee.id] ? employeesShiftCount[employee.id] : 0}`}
          </Grid>)}
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
      </Grid>
    </Paper>
  );
}

export default App;
