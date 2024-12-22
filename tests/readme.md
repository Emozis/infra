# K6를 활용한 서버 스트레스 테스트

서버의 성능 테스트를 위한 k6 스크립트입니다.

Grafana, influxdb를 활용한 시각화 도구를 사용하였습니다.

```
k6 run --out influxdb=http://localhost:8086/k6 script.js
```
