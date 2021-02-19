export function getDateFromYearWeekDay(d, w, y) { 
    const date = getDateOfWeek(w, y);;
    date.setDate(date.getDate() + d);
    return date;
}

function getDateOfWeek(w, y) {
    var d = (1 + (w - 1) * 7); // 1st of January + 7 days for each week
    return new Date(y, 0, d);
}

export function formatTime(string) {
    return string.split('.')[0].split('T')[1].substr(0,5);
}