import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    // 1단계: 30초동안 0->50 VUs로 증가 (워밍업)
    { duration: '30s', target: 50 },

    // 2단계: 1분동안 50 VUs 유지 (안정성 확인)
    { duration: '1m', target: 50 },

    // 3단계: 1분동안 50->100 VUs로 천천히 증가
    { duration: '1m', target: 100 },

    // 4단계: 1분동안 100 VUs 유지 (피크 부하 확인)
    { duration: '1m', target: 100 },

    { duration: '1m', target: 200 },

    { duration: '1m', target: 200 },

    { duration: '1m', target: 50 },

    { duration: '1m', target: 50 },

    // 5단계: 30초동안 점진적으로 0으로 감소 (정리)
    { duration: '30s', target: 0 },
  ],

  thresholds: {
    // 실패율 1% 이상이면 테스트 실패로 간주
    'http_req_failed': ['rate<0.01'],
    // 응답시간이 500ms를 넘으면 테스트 실패로 간주
    'http_req_duration': ['p(95)<500'],
  },
};

export default function () {
  const response = http.get('http://emogi-alb-1126438144.ap-northeast-2.elb.amazonaws.com/api/v1/character');

  // 응답 확인
  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });

  // 요청 간격을 좀 더 늘림 (1~3초 사이)
  sleep(1 + Math.random() * 2);
}

export function handleSummary(data) {
  return {
    "summary.html": htmlReport(data),
    "stdout": textSummary(data, { indent: " ", enableColors: true }),
  };
}