import decamelize from 'decamelize'
import { func } from 'prop-types';

const apiUrl = "api/v1";

function decamelizeObject(object) {
    return Object.entries(object).reduce((obj, entrie) => {
        const [key, value] = entrie;
        return ({
            ...obj,
            [decamelize(key)]: value
        })
    }, {})
}

export async function apiGet(endpoint, queryParams, options) {
    try {
        const queryString = queryParams ? `?${new URLSearchParams(decamelizeObject(queryParams)).toString()}` : '';
        const res = await fetch(`${apiUrl}/${endpoint}${queryString}`, options);

        const json = await res.json();
        return {
            viewState: json,
            status: res.status
        };
    } catch (error) {
        console.log('error', error)
        return error;
    }
}

export async function apiPost(endpoint, options) {
    try {
        console.log('{ ...options, method: POST}', { ...options, method: 'POST' })
        const res = await fetch(`${apiUrl}/${endpoint}`, {
            ...options,
            headers: {
                ...options.headers,
                'Content-Type': 'application/json;charset=utf-8'
            },
            body: JSON.stringify(options.body),
            method: 'POST'
        });
        const json = await res.json();
        return {
            viewState: json,
            status: res.status
        };
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