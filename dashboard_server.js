const http = require('http');
const fs = require('fs');
const path = require('path');

const DASHBOARD_DIR = '/home/hiropi4/raas-platform/dashboard';

const server = http.createServer((req, res) => {
    let filePath = path.join(DASHBOARD_DIR, req.url === '/' ? 'index.html' : req.url.split('?')[0]);
    
    // セキュリティチェック（ディレクトリトラバーサル防止）
    if (!filePath.startsWith(DASHBOARD_DIR)) {
        res.writeHead(403);
        res.end('Forbidden');
        return;
    }

    fs.readFile(filePath, (err, data) => {
        if (err) {
            res.writeHead(404);
            res.end('Not Found');
            return;
        }

        const ext = path.extname(filePath);
        let contentType = 'text/html';
        if (ext === '.png') contentType = 'image/png';
        if (ext === '.css') contentType = 'text/css';
        if (ext === '.js') contentType = 'text/javascript';

        res.writeHead(200, { 'Content-Type': contentType });
        res.end(data);
    });
});

server.listen(8000, () => {
    console.log('RaaS Dashboard server running on port 8000');
});
