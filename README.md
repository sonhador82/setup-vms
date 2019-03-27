### Подготовка окружения
см. env/README.md

### Конфигурирование сервисов (на запущенных вм-ках)
активировать окружение python+ansible, созданное в env, под рутом,
(в env ключ создаётся ssh для доступа к вм-кам.)

по-очередно запустить следующие плейбуки
```bash
cd /test_case/setup_vms
source source /test_case/setup-vms/venv/ansible-2.6/activate

# общие настройки для всех вм-ок
ansible-playbook ./setup_all.yml

# п.4 keepalived + nginx
ansible-playbook ./setup_keepalived.yml
ansible-playbook ./setup_nginx.yml

# п.5 consul + consul-server
ansible-playbook ./setup_consul.yml
ansible-playbook ./configure_consul_servers.yml

# п.6 consul-agents
ansible-playbook ./configure_consul_agents.yml
```

Что было не сделано - п.7, смок тесты.
Некоторые вопросы/костыли:
 - надо бы причесать, по ролям распихать
 - по keepalived, вроде только failover по тех заданию, без балансировки L4? (на собесе кстати прибрехнул, не keepalived я накатывал, а ucarp)
 - iptable-ы для consule (пропускает consul-client на порт consul-cluster), было лень прописывать ip-шники, по документации в консуле мождно вроде ключик прилепить на взаимодействыие нод, я бы лучше варик с ключем выбрал, нежели ограничение по ip
 - регистрацию редиса, как сервиса, не уверен что решил верным путём, но работает, разве что есть переходное состояние пару секунд..
 - нативный kvm вместо вагранта - потому что. Не работал я с ним, лень было разбираться. А вот для квм-а давно хотел накидать скриптики ) 

Протестировал на железе полный сетап: xeon-1220/16gb/ debian stretch

Поротестровал на ВМ-ке с nested виртуализацией только nginx+keepalive: kvm / ubuntu 16.04 (12GB/CPU host-passthrough)
