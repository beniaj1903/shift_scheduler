import { useEffect } from 'react'
import {
    Checkbox,
    Table,
    TableCell,
    TableRow,
    TableContainer,
    TableHead,
    Paper,
    TableBody
} from "@material-ui/core";
import { Warning } from "@material-ui/icons";

// project imports
import '../App.css'
import { formatTime } from "../Utils/DateHelper";
import { ok, warning, checkboxColor, employeeColors } from '../Utils/Colors'
/* 
    Component
    Name: DailyBox
    Description:  Manage a box that renders the daily shifts, the disponibility of each employee and the final result of shifts assignation
*/
const DailyBox = props => {

    // Init
    const {
        handleEmployeeCheckboxChange,
        handleCheckboxChange,
        availabilities,
        checkboxMode,
        employees,
        shiftIds,
        rows,
        day
    } = props;

    // Did Mount
    useEffect(() => {

    }, [])

    // Render
    return (
        <TableContainer component={Paper} className="Daily-box">
            <Table aria-label="simple table">
                <TableHead>
                    <TableRow>
                        <TableCell align="center" colSpan={checkboxMode ? 1 : 2} >{day}</TableCell>
                        {checkboxMode &&
                            employees.map(employee => {
                                const employeeAvailabilities = availabilities.filter(sa => sa.employee_id === employee.id);
                                const allChecked = employeeAvailabilities.length === shiftIds.length;
                                return <TableCell colSpan={1} align="center" key={employee.id} style={{ backgroundColor: employeeColors(employees, employee.id)}}>
                                    <Checkbox
                                        checked={Boolean(allChecked)}
                                        color="default"
                                        onChange={() => handleEmployeeCheckboxChange(employee.id, shiftIds, !Boolean(allChecked))}
                                    />
                                    {employee.name}
                                </TableCell>
                            })}
                    </TableRow>
                </TableHead>
                <TableBody>
                    {rows.map((row) => (
                        <TableRow key={row.id}>
                            <TableCell align="center"
                                style={{ backgroundColor: row.employee_id ? ok : warning }}
                            >
                                {`${formatTime(row.start_time)}-${formatTime(row.end_time)}`}
                            </TableCell>
                            {
                                checkboxMode ?
                                    employees.map(employee => {
                                        const checked = availabilities.find(av => av.employee_id === employee.id && av.shift_id === row.id);
                                        return <TableCell key={employee.id}>
                                            <Checkbox
                                                checked={Boolean(checked)}
                                                color="default"
                                                onChange={() => handleCheckboxChange(employee.id, row.id, !Boolean(checked))}
                                            />
                                        </TableCell>
                                    })
                                    : <TableCell align="center" style={{ backgroundColor: employeeColors(employees, row.employee_id)}} >{
                                        row.employee === '' ? <Warning /> : row.employee
                                    }
                                    </TableCell>
                            }
                        </TableRow>
                    ))}
                </TableBody>
            </Table>
        </TableContainer>
    )
}

export default DailyBox