FROM centos:8

RUN dnf update -y \
	&& dnf groupinstall -y "Development Tools" \
	&& dnf install -y ncurses-devel \
	&& dnf install -y hmaccalc zlib-devel binutils-devel elfutils-libelf-devel cmake elfutils-devel elfutils-libs python3 readline-devel iperf3

RUN alternatives --set python /usr/bin/python3

ENV LD_LIBRARY_PATH /usr/local:/usr/local/lib:/usr/local/lib64

WORKDIR /src

RUN cd /src \
	&& git clone https://github.com/acmel/dwarves \
	&& mkdir -p dwarves/build \
	&& cd dwarves/build \
	&& git checkout v1.18 \
	&& cmake .. \
	&& make \
	&& make install

RUN cd /src \
	&& git clone https://github.com/llvm/llvm-project.git \
	&& mkdir llvm-project/build \
	&& cd llvm-project/build \
	&& git checkout llvmorg-10.0.1 \
	&& cmake \
		-DLLVM_ENABLE_PROJECTS=clang \
		-DLLVM_ENABLE_RTTI=true \
		-DLLVM_TARGETS_TO_BUILD="BPF;X86" \
		-DCMAKE_BUILD_TYPE=Release \
		-G "Unix Makefiles" \
		../llvm \
	&& make \
	&& make install

RUN cd /src \
	&& git clone -b v5.8.17 --single-branch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git \
	&& cd linux-stable/tools/lib/bpf \
	&& make \
	&& make install \
	&& cd ../../bpf/bpftool \
	&& make \
	&& make install

RUN cd /src \
	&& git clone https://github.com/iovisor/bcc \
	&& mkdir bcc/build \
	&& cd bcc/build \
	&& git checkout v0.16.0 \
	&& cmake .. \
	&& make \
	&& make install

RUN cd /src \
	&& git clone https://github.com/iovisor/bpftrace \
	&& mkdir bpftrace/build \
	&& cd bpftrace/build \
	&& git checkout v0.11.2 \
	&& cmake .. \
	&& make \
	&& make install
