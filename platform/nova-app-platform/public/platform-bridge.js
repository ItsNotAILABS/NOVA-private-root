/* NOVA App Platform Browser Bridge
 * Include from NOVA Phone or Capsule Studio with:
 * <script src="http://127.0.0.1:8899/public/platform-bridge.js"></script>
 */
(function () {
  const defaultBaseUrl = "http://127.0.0.1:8899";

  function baseUrl() {
    return window.NOVA_PLATFORM_URL || defaultBaseUrl;
  }

  async function request(path, options) {
    const res = await fetch(baseUrl() + path, {
      ...options,
      headers: {
        "content-type": "application/json",
        ...(options && options.headers ? options.headers : {})
      }
    });
    const payload