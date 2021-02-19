import green from '@material-ui/core/colors/lightGreen'
import red from '@material-ui/core/colors/red'
import lime from '@material-ui/core/colors/lime'
import purple from '@material-ui/core/colors/purple'
import yellow from '@material-ui/core/colors/yellow'
import brown from '@material-ui/core/colors/brown'
import pink from '@material-ui/core/colors/pink'
import grey from '@material-ui/core/colors/grey'


export const ok = green[300];
export const warning = red[300];
export const checkboxColor = grey[300];

export const employeeColors = (employees, employeeId) => {
    const colorArray = [
        lime[300],
        purple[300],
        pink[200],
        brown[300],
        yellow[300]
    ];
    const colorObj = employees.reduce((obj, employee, index) => ({ ...obj, [employee.id]: colorArray[index] }), {})
    return colorObj[employeeId];
}