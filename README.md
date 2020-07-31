# ft_service
### Minicube 설치

맥OS에서 가상화 지원 여부를 확인하려면, 아래 명령어를 터미널에서 실행한다.

```
sysctl -a | grep -E --color 'machdep.cpu.features|VMX'

```

만약 출력 중에 (색상으로 강조된) `VMX`를 볼 수 있다면, VT-x 기능이 머신에서 활성화된 것이다.

[Minikube 설치](https://kubernetes.io/ko/docs/tasks/tools/install-minikube/)

(42homebrew 설치 후 )brew install minikube

[docker container 활용 #5](https://ahnseungkyu.com/245)

## Nginx

docker build -t  nginx .

docker run -it -p 80:80 -p 443:443 nginx

하면 프로그램이 계속 돌아가면서 localhost에 nginx가 떠야하는데 404page not found가 뜸

→ 해결: 이전 ft_server config 파일에서 root를 /www 로 변경

## 왜 daemon off 를 쓰나?

[What is the difference between nginx daemon on/off option?](https://stackoverflow.com/questions/25970711/what-is-the-difference-between-nginx-daemon-on-off-option)

쿠버네티스 환경에 nginx 배포하기

[[쿠버네티스 #1] 쿠버네티스 오브젝트와 컨트롤러](https://boying-blog.tistory.com/4)

## 쿠버네티스 개념

**오브젝트** : 

- Pod, Service, namespace, Volume, ConfigMap 등
- 사용자는 이 오브젝트들을 조건에 맞게 생성하여 일을 시킨다.
- 예를들면 Pod는 실제 실행되는 컨테이너를 가지고 있는 오브젝트로

    Python flask 웹서버 컨테이너를 가지고 있는 Pod를 생성하고 이 Pod를 외부에서 접근이 가능하게 하기 위해 Service로 묶어 특정 Service를 만든다.

    각 Pod와 Service의 연결을 위해 Label 설정도 해주고 Pod에서 실행할 flask 웹서버 컨테이너의 조건을 지정해 주기도 한다.

**컨트롤러** : 

- Replicaset, Deployment, Job, 등
- 이러한 오브젝트를 관리하기 쉽게하는 역할을 한다.
- 예를들면 Replicaset의 경우 Pod를 관리하는 컨트롤러이다. Pod의 개수를 지정하여 특정 수를 유지한다거나 Pod를 어떤 컨테이너 이미지의 어떤 포트로 배포할지 등에 대한 정보를 가지고 있어 이 쓰여진 정보대로 Pod를 배포하거나 삭제하거나 한다.
- Deployment는 pod 업데이트를 위해 사용되는 기본 컨트롤러

→ 오브젝트와 컨트롤러는 yaml이라는 파일 형식으로 내용을 적고 yaml 파일을 kubectl 명령어를 통해 쿠버네티스 클러스터에 배포함으로써 사용한다.

**Pod**:

- 쿠버네티스는 컨테이너를 직접 관리하지 않고 쿠버네티스가 담겨있는 Pod를 컨트롤 한다. 사용자는 이 Pod를 실행하거나 종료하거나 복제하거나 해서 관리한다.

**Service**:

- ex) Load Balancer

pod도 ip가 있는데 왜 굳이 Service라는걸로 한 번 더 포장해서 배포를 하는걸까?

그 이유는 pod의 휘발성 때문이다. 앞서 말했던 pod들은 쉽게 죽기도하고 재 실행되기도 한다. 이러한 과정속에서 pod의 ip는 고정이 되있는게 아닌 변화하게 되는데 이 때문에 이러한 pod를 service라는 오브젝트로 포장해서 하나의 ip로 접근 할 수 있게 하는 것이다.

- service 종류와 목적

관리자가 특정 서비스에 접근하기 위해서는 ClusterIP를

내부 사용자가 특정 서비스에 접근하기 위해서는 NodePort를

외부 사용자가 특정 서비스에 접근하기 위해서는 LoadBalancer를 사용한다.

```jsx
apiVersion: v1
kind: Service
metadata:
  name: example-svc
spec:
  type: ClusterIP //
  selector:
    app: example-svc //연결하고 싶은 pod
  ports:
  - port: 8000 //서비스에 대한 port
    targetPort: 8000 //해당 서비스가 타겟으로 할 pod의 port
```

**MetalLB:**

[[쿠버네티스 #6] Kubernets metallb를 사용한 로드밸런서 타입 서비스 배포](https://boying-blog.tistory.com/16)

- 온프레미스 환경에서도 로드밸런서 타입의 서비스를 배포할 수 있게 해주는 도구이다.
- 온프레미스 환경이란? On-premise 소프트웨어 등 솔루션을 클라우드 같이 원격 환경이 아닌 자체적으로 보유한 전산실 서버에 직접 설치해 운영하는 방식

minikube 설치 후 위 상단바에서 체크, minikube start, 하고 virtual box 셋팅 metallb 깔기

[https://42born2code.slack.com/archives/C03DJS74G/p1576609022008300](https://42born2code.slack.com/archives/C03DJS74G/p1576609022008300)

As it is written, you should use "virtualbox" driver instead of "hyperkit" since hyperkit needs root
You will need to have VirtualBox installed with the MSC
From https://minikube.sigs.k8s.io/docs/start/macos/:

- minikube 와 virtual box 를 연결

```jsx
minikube config set vm-driver virtualbox
export MINIKUBE_HOME=/Users/jhur/goinfre/
minikube start
```

- metallb  설치

```jsx
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml
```

-중간 정리

minikube start → metallb 설치 →eval $(minikube docker-env) 도커랑 쿠버네티스 연결→ 도커 이미지 빌드→ kubectl apply -f metallb config.yaml → nginx.yaml → minikube service list로 확인 → minikube delete

**nodeport vs port vs targetport**

[[번역] 쿠버네티스에서의 Port, TargetPort, NodePort](https://kimmj.github.io/kubernetes/port-targetport-nodeport-in-kubernetes/)

[[발번역] Kubernetes NodePort vs LoadBalancer vs Ingress?? 언제 무엇을 써야 할까??](https://blog.leocat.kr/notes/2019/08/22/translation-kubernetes-nodeport-vs-loadbalancer-vs-ingress)

- NodePort는 모든 Node(VM 우리의 경우에는 virtual box)에 특정 포트를 열어 두고, 이 포트로 보내지는 모든 트래픽을 서비스로 포워딩한다.

## delete

kubectl delete service/deployment --all

## SSL

[[정보보안] SSL(Secure Socket Layer) 이란](https://12bme.tistory.com/80)

## SSH key

왜 ssh 를 쓰라고 하는 것일까?

- 서버 작업을 처리해야 할 일이 있을 때 마다 매번 해당 서버가 위치한 곳으로 이동할 수는 없고, 이동해서 관리하자니 관리해야 할 서버가 점차 많아지게 되면 각각의 서버로 이동하여 일일히 모니터를 연결하여 작업을 할 수는 없는 노릇입니다.→ 그래서 원격접속(ssh)를 쓴다

[SSH란 무엇이고 왜 사용하나요? Telnet과의 차이점은요? - JooTC](https://jootc.com/p/201808031460)

[리눅스 - ssh-keygen으로 공개키를 생성해 패스워드 없이 로그인](https://m.blog.naver.com/PostView.nhn?blogId=jsky10503&logNo=220750393375&proxyReferer=https:%2F%2Fwww.google.com%2F)

[SSH 접속 가능한 알파인 도커 이미지 빌드](https://zetawiki.com/wiki/SSH_접속_가능한_알파인_도커_이미지_빌드)

## 옵션 축제

sed -i : 파일내용 수정

-t : RSA DSA 등 공개 키의 타입을 지정한다.

-f: 저장할 키 값의 파일 명

-N thepassphrase : 프롬프트가 나타나지 않도록 명령 줄 인수를 통해 암호를 제공 할 수 있습니다 . 여전히 암호화를 통해 키를 안전하게 보호 하고 키 쌍을 일반 텍스트로 사용하고 싶지 않습니다.

mkdir -p 옵션을 사용할 경우에는 존재하지 않는 중간의 디렉토리를 자동을 생성해 준다.

[RSA vs DSA](https://www.notion.so/fe437d3328be4ed5bb1d134ed10db2c0)

## SSH LOGIN TEST

<도커 컨테이너 ver> 이미지 빌드 후 테스트할 시

ssh 아이디@localhost -p 10022

<쿠버네티스 ver>

ssh 아이디@(minikube ip address) -p 10022

ssh root@192.168.99.119 -p 30022

비번 0000

## mysql

[쿠버네티스 #5 - 디스크 (볼륨/Volume)](https://bcho.tistory.com/1259)

```c
docker build -t mysql_img .

docker run -d -p 3306:3306 mysql_img

docker ps

docker exec -it 3 /bin/sh

mysql

show databases;
```

/ # cd tmp
/tmp # ls
[entrypoint.sh](http://entrypoint.sh/) mysql_init
/tmp # bash mysql_init
/bin/sh: bash: not found
/tmp # sh mysql_init

## CrashLoopBackOff 문제 해결 방법

kubectl get pods

kubectl logs pod이름

[문제해결 | Kubernetes Engine 문서 | Google Cloud](https://cloud.google.com/kubernetes-engine/docs/troubleshooting?hl=ko)

## Telegraf - InfluxDB - Grafana

- 데이터 수집 - 저장 - 시각화

[오픈소스 시스템 모니터링 에이전트, Telegraf](https://si.mpli.st/dev/2017-09-10-introduction-to-telegraf/)

influxdb, telegraf, grafana 순서로 세팅

## 2020-07-27

- 문제

```bash
🤷 This control plane is not running! (state=Stopped)
❗ This is unusual - you may want to investigate using "minikube logs"
👉 To fix this, run: "minikube start"
c2r4s5% minikube logs
E0727 12:25:40.911004 71419 logs.go:200] Failed to list containers for "kube-apiserver": docker: NewSession: new client: new client: dial tcp 127.0.0.1:56168: connect: connection refused
E0727 12:25:43.961807 71419 logs.go:200] Failed to list containers for "etcd": docker: NewSession: new client: new client: dial tcp 127.0.0.1:56168: connect: connection refused
E0727 12:25:47.141326 71419 logs.go:200] Failed to list containers for "coredns": docker: NewSession: new client: new client: dial tcp 127.0.0.1:56168: connect: connection refused
E0727 12:25:50.704364 71419 logs.go:200] Failed to list containers for "kube-scheduler": docker: NewSession: new client: new client: dial tcp 127.0.0.1:56168: connect: connection refused
E0727 12:25:54.240200 71419 logs.go:200] Failed to list containers for "kube-proxy": docker: NewSession: new client: new client: dial tcp 127.0.0.1:56168: connect: connection refused
E0727 12:25:57.192304 71419 logs.go:200] Failed to list containers for "kubernetes-dashboard": docker: NewSession: new client: new client: dial tcp 127.0.0.1:56168: connect: connection refused
E0727 12:26:00.387587 71419 logs.go:200] Failed to list containers for "storage-provisioner": docker: NewSession: new client: new client: dial tcp 127.0.0.1:56168: connect: connection refused
E0727 12:26:03.297975 71419 logs.go:200] Failed to list containers for "kube-controller-manager": docker: NewSession: new client: new client: dial tcp 127.0.0.1:56168: connect: connection refused
==> Docker <==
E0727 12:26:06.663945 71419 logs.go:178] command /bin/bash -c "sudo journalctl -u docker -n 60" failed with error: NewSession: new client: new client: dial tcp 127.0.0.1:56168: connect: connection refused output: ""

==> container status <==
E0727 12:26:09.049868 71419 logs.go:178] command /bin/bash -c "sudo `which crictl || echo crictl` ps -a || sudo docker ps -a" failed with error: NewSession: new client: new client: dial tcp 127.0.0.1:56168: connect: connection refused output: ""

==> describe nodes <==
E0727 12:26:12.215229 71419 logs.go:178] command /bin/bash -c "sudo /var/lib/minikube/binaries/v1.18.3/kubectl describe nodes --kubeconfig=/var/lib/minikube/kubeconfig" failed with error: NewSession: new client: new client: dial tcp 127.0.0.1:56168: connect: connection refused output: ""

==> dmesg <==
E0727 12:26:14.588235 71419 logs.go:178] command /bin/bash -c "sudo dmesg -PH -L=never --level warn,err,crit,alert,emerg | tail -n 60" failed with error: NewSession: new client: new client: dial tcp 127.0.0.1:56168: connect: connection refused output: ""

==> kernel <==
E0727 12:26:18.344170 71419 logs.go:178] command /bin/bash -c "uptime && uname -a && grep PRETTY /etc/os-release" failed with error: NewSession: new client: new client: dial tcp 127.0.0.1:56168: connect: connection refused output: ""

==> kubelet <==
E0727 12:26:20.529559 71419 logs.go:178] command /bin/bash -c "sudo journalctl -u kubelet -n 60" failed with error: NewSession: new client: new client: dial tcp 127.0.0.1:56168: connect: connection refused output: ""

❗ unable to fetch logs for: Docker, container status, describe nodes, dmesg, kernel, kubelet
```

→해결 : nginx.yaml  에서 ssh port 를 22로 해놓고 수정을 안했음. 이 맥에서 22 이미 쓰고 있어서 nginx.config 에 30022 라고 고쳐놓고!!!

## wordpress - db 연동(wordpress.sql)

- wordpress 에 로그인해서 post, comment 도 하고 add user 3명 함.
- phpmyadmin 들어가서 export 해서 파일을 다운로드 받는다.

## Mysql % 의미

- '%' 의 Host 값은 모든 호스트 이름과 매치

[:::MySQL Korea:::](http://www.mysqlkorea.com/sub.html?mcode=manual&scode=01&m_no=21405&cat1=5&cat2=126&cat3=159&lang=k)

## nohup

nohup 은 “no hangups” 라는 의미로, 리눅스/유닉스에서 쉘 스크립트파일을 데몬 형태로 실행시키는 명령어다. 터미널이 끊겨도 실행한 프로세스는 계속 동작하게 한다.

[nohup 명령어로 어플리케이션 실행하기](https://medium.com/@jinnyjinnyjinjin/nohup-%EB%AA%85%EB%A0%B9%EC%96%B4%EB%A1%9C-%EC%96%B4%ED%94%8C%EB%A6%AC%EC%BC%80%EC%9D%B4%EC%85%98-%EC%8B%A4%ED%96%89%ED%95%98%EA%B8%B0-d66cc85d4f9)

## MySQL Socket error

```bash
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/run/mysqld/mysqld.sock' (2)
NO_UP

kubectl get pods

kubectl logs mysql-6c79475bd5-bzblc
```

→해결:  대쉬가 잘못되어있었음! 대부분 문법에러 

mysql wordpress -u root --skip-password < /tmp/wordpress.sql (맞는거)

# mysql wordpress -u root -skip--password < /tmp/wordpress.sql (틀린거)

## PV PVC

[쿠버네티스 볼륨(kubernetes volume : PersistentVolume, PersistentVolumeClaim)](https://arisu1000.tistory.com/27849)

## telegraph config

telegraph docker 로 접근하려면 아래와 같은 내용으로 못들어가게 함. 그래서 telegraph config 구글에 쳐서 나온거 긁어옴.

```bash
c2r5s5% docker run -it -p 3000:3000 tel
2020-07-28T10:55:00Z I! Starting Telegraf 1.14.0
2020-07-28T10:55:00Z E! [telegraf] Error running agent: No config file specified, and could not find one in $TELEGRAF_CONFIG_PATH, /root/.telegraf/telegraf.conf, or /etc/telegraf/telegraf.conf
```

[](https://raw.githubusercontent.com/influxdata/telegraf/master/etc/telegraf.conf)

## HOW TO DEPLOY INFLUXDB / TELEGRAF / GRAFANA ON K8S?

[How to Deploy InfluxDB / Telegraf / Grafana on K8s?](https://octoperf.com/blog/2019/09/19/kraken-kubernetes-influxdb-grafana-telegraf/)

## 왜 telegraf config 파일이 안 먹지?

```docker
./telegraf: line 18: [global_tags]: not found
./telegraf: line 22: user: not found
./telegraf: line 26: [agent]: not found
./telegraf: line 28: interval: not found
./telegraf: line 31: round_interval: not found
./telegraf: line 36: metric_batch_size: not found
./telegraf: line 41: metric_buffer_limit: not found
./telegraf: line 47: collection_jitter: not found
./telegraf: line 51: flush_interval: not found
./telegraf: line 55: flush_jitter: not found
./telegraf: line 64: precision: not found
hostname: sethostname: Operation not permitted
./telegraf: line 96: omit_hostname: not found
```

- 우선 config 파일이 틀렸었음. [[outputs.influxdb]] urls = ["[http://influxdb-service:8086](http://influxdb-service:8086/)"] 여기서 influxdb-service 가 로컬호스트(127.0.0.1)로 되어있었는데 그걸 바꿔주지 않았음.
- 그리고 dockerfile에서 telegraf 라는 디렉터리 안에 telegraf 라는 동일한 이름의 파일이 있었는데 자꾸 디렉터리를 실행시키고 있었음. 그래서 안됐었던 것. 그리고 init.sh파일 만들기 싫어서 workdir 로 현재 디렉터리 변경 후 파일을 실행시켜주었음.

## grafana provisioning-datasource yaml

[Using InfluxDB in Grafana](https://grafana.com/docs/grafana/latest/features/datasources/influxdb/)

## FTPS

- filezilla 통해서 확인

[66. [Docker] Docker 컨테이너로의 sftp 사용 - filezilla를 통한 예제](https://m.blog.naver.com/PostView.nhn?blogId=alice_k106&logNo=220650722592&proxyReferer=https:%2F%2Fwww.google.com%2F)

‘-j’ : 만약, 사용자 홈디렉토리가 존재하지 않을 경우 자동으로 생성한다.

‘-Y 2’ : anonymous session 을 포함한 SSL/TLS security mechanisms 를 사용하지 않는 접속을 거부 “—with-tls 옵션으로 컴파일 되어야 하고

- passive active

[FTP 액티브(Active)와 패시브(Passive) 차이점 - 익스트림 매뉴얼](https://extrememanual.net/3504)

호스트 미니쿠베 ip, 포트 21 로 빠른 연결
