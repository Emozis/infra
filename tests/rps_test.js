import http from 'k6/http';
import { check } from 'k6';
import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import { textSummary } from "https://jslib.k6.io/k6-summary/0.0.1/index.js";

export const options = {
  scenarios: {
    rps_test: {
      executor: 'ramping-arrival-rate',  // 점진적으로 RPS를 증가시키는 실행자
      startRate: 50,                     // 시작 RPS
      timeUnit: '1s',                    // 시간 단위
      preAllocatedVUs: 100,             // 미리 할당할 VU 수
      maxVUs: 1000,                      // 최대 VU 수
      stages: [
        // 워밍업: 50 RPS로 시작
        { duration: '30s', target: 50 },  
        
        // 1단계: 50 -> 100 RPS로 증가
        { duration: '1m', target: 100 },
        
        // 2단계: 100 RPS 유지
        { duration: '2m', target: 100 },
        
        // 3단계: 100 -> 200 RPS로 증가
        { duration: '1m', target: 200 },
        
        // 4단계: 200 RPS 유지 (피크 부하)
        { duration: '2m', target: 200 },
        
        // 5단계: 점진적으로 감소
        { duration: '1m', target: 50 },
        
        // 정리: 완전히 감소
        { duration: '30s', target: 0 }
      ]
    }
  },
  thresholds: {
    http_req_failed: ['rate<0.01'],     // 1% 미만의 실패율
    http_req_duration: ['p(95)<500'],   // 95% 요청이 500ms 이하
    'http_reqs': ['rate>50'],           // 최소 50 RPS 유지
  }
};

export default function () {
  const response = http.get('http://emogi-alb-1126438144.ap-northeast-2.elb.amazonaws.com/api/v1/character');

  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });
}

export function handleSummary(data) {
  return {
    "rps_summary.html": htmlReport(data),
    "stdout": textSummary(data, { indent: " ", enableColors: true }),
  };
}