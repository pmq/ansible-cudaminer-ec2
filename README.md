ansible-cudaminer-ec2
=====================

Ansible Playbook to mine dogecoins, or any other cryptocurrency supported by the most excellent [CudaMiner](https://github.com/cbuchner1/CudaMiner) by Christian Buchner, on AWS EC2.

Apologies in advance for the [dogespeak](http://dogecoin.com/)! Have fun.

##Such Crypto
- Get an AWS account
- Buy some quality GPU instance time, this playbook is made for the stock Amazon HVM 64-bit AMI (`amzn-ami-hvm-2013.09.2.x86_64-ebs (ami-e9a18d80)`) on a `g2.2xlarge`; check the pricing of course, but Spot Instances are a nice way of proceeding
- Install your SSH PEM file to `~/.ssh/aws-mining.pem` (or anywhere you prefer, but in that case you'll need to change this default in `run.sh`, in the `SSH_IDENTITY` var)
- Install Ansible
- Clone this repository, or get it as a ZIP
- Edit the `hosts` file in your clone and input your EC2 instances (or use the `ec2.py` inventory in Ansible to retrieve it dynamically)
- Edit the `to-the-moon.yml` file to update it with your pool URL, your worker login and password. Here I have used the [Dogechain Pool](https://pool.dogechain.info):

```
  vars:
    pool_url: stratum+tcp://stratum2.dogechain.info:3333
    worker_name: myname
    worker_passwd: mypasswd
```

- run `./run.sh ping` to check if you can SSH to the instances
- run `./run.sh mine` to start installing the instances and start mining!

##Much Caveats
- Ansible wasn't designed to drive your EC2 instances from your laptop. There's nothing wrong with that, but if you do, some of the SSH commands will stall forever, in a random fashion. That means the sensible way is to have another EC2 machine in the same region, driving the worker nodes. I personally use a `t1.micro` to be in the free tier.
- As of 3/26/14, on the classic amzn-ami-hvm-2013.09.2.x86_64-ebs (ami-e9a18d80), I had to change the last g++ call when building CudaMiner to add `-ldl`, like this:

```
g++  -g -O2 -pthread -L/usr/local/cuda/lib64  -o cudaminer cudaminer-cpu-miner.o cudaminer-util.o wrapnvml.o cudaminer-sha2.o cudaminer-scrypt.o cudaminer-maxcoin.o cudaminer-blakecoin.o cudaminer-sha3.o cudaminer-scrypt-jane.o salsa_kernel.o sha256.o keccak.o blake.o cudaminer-blake.o fermi_kernel.o kepler_kernel.o test_kernel.o nv_kernel.o nv_kernel2.o titan_kernel.o -lcurl   compat/jansson/libjansson.a -lpthread  -lcudart -fopenmp -lcrypto -lssl  -lcrypto -lssl -ldl
```
Then run make again, actually only to confirm that everything is OK. I haven't automated this in the released version, let me know in the issues if you need it.

##Very Shibe
Profit! If you like this, you can tip me at `D6svCymQUYK7CnaVvmxasrZRiKDGBrRAkX`.
