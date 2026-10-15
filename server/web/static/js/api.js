// 서버 API 호출. 오류는 서버가 보낸 {"error": "..."} 문구로 throw 한다.
export class ApiError extends Error {
  constructor(message, status) {
    super(message);
    this.status = status;
  }
}

let onUnauthorized = () => {};
export function setUnauthorizedHandler(fn) {
  onUnauthorized = fn;
}

async function request(method, path, body, headers = {}) {
  const opts = { method, headers: { ...headers }, credentials: 'same-origin' };
  if (body instanceof Blob) {
    opts.body = body;
  } else if (body !== undefined) {
    opts.body = JSON.stringify(body);
    opts.headers['content-type'] = 'application/json';
  }
  let res;
  try {
    res = await fetch(path, opts);
  } catch {
    throw new ApiError('서버에 연결할 수 없어요', 0);
  }
  const data = res.headers.get('content-type')?.includes('application/json') ? await res.json() : null;
  if (!res.ok) {
    if (res.status === 401 && !path.startsWith('/api/auth/')) onUnauthorized();
    throw new ApiError(data?.error || `오류가 났어요 (${res.status})`, res.status);
  }
  return data;
}

export const api = {
  get: (path) => request('GET', path),
  post: (path, body = {}) => request('POST', path, body),
  put: (path, body = {}) => request('PUT', path, body),
  del: (path) => request('DELETE', path),
  /** 이미지 파일 올리기 → assets 행 */
  upload: (file) => request('POST', '/api/assets', file, { 'x-file-name': encodeURIComponent(file.name || 'image') }),
};

/** 파일 주소 (로그인 쿠키로 보호됨) */
export const assetUrl = (id, thumb = true) => `/api/assets/${id}/${thumb ? 'thumb' : 'file'}`;
