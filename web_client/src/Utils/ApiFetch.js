const apiUrl = "api/v1";


export async function apiGet(endpoint, options) {
    try {
        const res = await fetch(`${apiUrl}/${endpoint}`, options);
        const json = await res.json();
        console.log('json', json)
        console.log('res', )
        return {
            viewState: json,
            status: res.status
        };
    } catch (error) {
        return error;
    }
}

export async function apiPost(endpoint, options) {
    try {
        const res = await fetch(`${apiUrl}/${endpoint}`, options);
        const json = await res.json();
        return json;
    } catch (error) {
        return error;
    }
}

export async function apiDelete(endpoint, options) {
    try {
        const res = await fetch(`${apiUrl}/${endpoint}`, options);
        const json = await res.json();
        return json;
    } catch (error) {
        return error;
    }
}

export async function apiPut(endpoint, options) {
    try {
        const res = await fetch(`${apiUrl}/${endpoint}`, options);
        const json = await res.json();
        return json;
    } catch (error) {
        return error;
    }
}