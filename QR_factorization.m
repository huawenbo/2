% ���ݳ�ʼ����
A = [1 2 3 4; 1 4 5 6; 1 5 6 7; 1 8 9 10; 1 11 12 13];
B = [1 2 3 1 4; 1 4 1 6 6; 1 5 6 7 5; 1 8 9 10 1; 1 6 2 6 3];
% [q r] = qrs(B)
% [q r] = qrg(B)
[q,r,p] = qrd(A)
% ����������������䣺
% A = input('������ԭʼ����')

% ����Gran-Schmidt���������������������ȵķ��󣨷��������
function [Q, R] = qrs(A)
[m, n] = size(A);
p = zeros(m, n);
Q = zeros(m, n);
R = zeros(m, n);
for i = 1:n
    if i == 1    
        p(:, i) = A(:, i);
        Q(:, i) = p(:, i)/norm(p(:, i), 2);
        R(1, 1) = norm(p(:, i), 2);  
    else
        temp = zeros(n, 1);
        for j = 1:i-1
            R(j, i) = (A(:, i)' * p(:, j)) / (norm(p(:, j), 2) * norm(p(:, j), 2));
            temp = temp +  R(j, i) * p(:, j);
            R(j, i) = R(j, i) .* R(j, j);
        end
        p(:, i) = A(:, i) - temp;
        Q(:, i) = p(:, i) / norm(p(:, i), 2);
        R(i, i) = norm(p(:, i), 2); 
    end    
end
end
% ����householder���������Ԫ��QR�ֽ��㷨��
function [Q,R,p] = qrd(A)
[m,n] = size(A);
Q = eye(m);
p = eye(n);
for j=1:n
    c(j) = chengfa(A(1:m,j)',A(1:m,j));
end
[cr,r]=max(c);
for k=1:n-1
    H_t=eye(m);
    if(cr<=0),break;end
    c([k r])=c([r k]);
    % p��¼��ԭʼ������н�����Ϣ��
    p(:,[k r])=p(:,[r k]);
    % ������ʹ���з������
    A(1:m,[k r])=A(1:m,[r k]);
    H=hst(A(k:m,k));
    A(k:m,k:n)=chengfa(H,A(k:m,k:n));
    H_t(k:end,k:end)=H;
    Q=chengfa(H_t,Q);
    for j=k+1:n
        c(j)=c(j)-A(k,j)^2;
    end
    [cr,r]=max(c(k+1:n));
    r=r+k;
end
Q=Q';
R=A;
end
% ��x��householder�������㷨��
function [H]=hst(x)                 
xmod=sqrt(chengfa(x',x));
alpha=-sign(x(1))*xmod;
x(1)=x(1)+alpha;
u=x/sqrt(sum(chengfa(x',x)));
H=eye(length(x))-2*chengfa(u,u');
end
% ����Givens�仯��QR�ֽ��㷨��ֻ�����ڷ�����û������Ԫ����
function [Q,R]=qrg(A)
[N,M]=size(A);
R=zeros(N);
T=eye(N);
B=A;
for j=1:N-1
    Tj=eye(N+1-j);T_t=eye(N);
    B=B(min(j,2):end,min(j,2):end);
    b=B(:,1);
    for i=2:N+1-j
        temp=eye(N+1-j);
        cs=sqrt(b(1)^2+b(i)^2);
        c=b(1)/cs;
        s=b(i)/cs;
        temp(1,1)=c;
        temp(i,i)=c;
        temp(i,1)=-s;
        temp(1,i)=s;
        b=chengfa(temp,b);
        Tj=chengfa(temp,Tj);
    end
    B=chengfa(Tj,B);
    R(j,j:end)=B(1,:);
    T_t(j:end,j:end)=Tj;
    T=chengfa(T_t,T);
end
R(j+1,j+1:end)=B(end,end);
Q=T';
end

function [C]=chengfa(A,B)
a=size(A);
b=size(B);
C=zeros(a(1),b(2));
for i=1:a(1)
    for j=1:b(2)
        for k=1:a(2)
            C(i,j)=C(i,j)+A(i,k)*B(k,j);
        end
    end
end
end
