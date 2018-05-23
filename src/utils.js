function toParams(object, prefix = '') {
  if (Array.isArray(object)) {
    return object.map(nestedVal => toParams(nestedVal, `${prefix}[]`)).join('&');
  } else if (typeof object === 'object') {
    return Object.keys(object)
      .map(key => toParams(object[key], `${prefix}[${key}]`))
      .join('&');
  }
  return `${prefix}=${object}`;
}

export function objectToParams(object) {
  if (!object || typeof object !== 'object') return '';
  const params = Object.entries(object)
    .map(([key, value]) => toParams(value, key))
    .join('&');
  return encodeURI(`?${params}`);
}

export function request(url, body, method = 'GET', headerOptions) {
  const headers = Object.assign({
    Mode: 'cors',
    Charset: 'utf-8',
    'X-Requested-With': 'XMLHttpRequest',
  }, headerOptions);

  return fetch(url, {
    method,
    headers,
    credentials: 'same-origin',
    body,
  });
}
