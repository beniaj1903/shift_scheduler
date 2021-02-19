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
import { formatTime } from "../Utils/DateHelper";

/* 
    Component
    Name: DailyBox
    Description:  Manage a box that renders the daily shifts, the disponibility of each employee and the final result of shifts assignation
*/
const DailyBox = props => {

    // Init
    const {
        handleCheckboxChange,
        availabilities,
        checkboxMode,
        employees,
        rows,
        day
    } = props;

    // Did Mount
    useEffect(() => {

    }, [])

    // Render
    return (
        <TableContainer component={Paper}>
            <Table aria-label="simple table">
                <TableHead>
                    <TableRow>
                        <TableCell align="center" colSpan={checkboxMode ? 1 : 2}>{day}</TableCell>
                        {checkboxMode &&
                            employees.map(employee => <TableCell colSpan={1} align="center" key={employee.id}>
                                {employee.name}
                            </TableCell>)}
                    </TableRow>
                </TableHead>
                <TableBody>
                    {rows.map((row) => (
                        <TableRow key={row.id}>
                            <TableCell align="center">{`${formatTime(row.start_time)}-${formatTime(row.end_time)}`}</TableCell>
                            {
                                checkboxMode ?
                                    employees.map(employee => {
                                    const checked = availabilities.find(av => av.employee_id === employee.id && av.shift_id === row.id);
                                    return <TableCell key={employee.id}>
                                        <Checkbox
                                            checked={Boolean(checked)}
                                            onChange={() => handleCheckboxChange(employee.id, row.id, !Boolean(checked))}
                                        />
                                    </TableCell>
                                    })
                                    : <TableCell align="center">{
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