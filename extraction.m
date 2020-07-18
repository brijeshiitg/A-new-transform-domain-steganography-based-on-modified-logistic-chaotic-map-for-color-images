
function f = extraction(stego_image)
	%set initial values of x, y, z between [0,1]
	x=0.3;
	y=0.6;
	z=0.9;
	%set control parameter values alpha, beta, gamma between [0.5,4]
	alpha = 1;
	beta = 2;
	gamma = 3;

	SI = imread(stego_image);
	[i,j,k] = size(SI);
    m = 512;
    n = 512;
	mask = zeros(1,m*n);
	SM = zeros(m,n);
	flag = ones(i,j,k);

	LS = liftwave('haar','Int2Int');
    [CA,CH,CV,CD] = lwt2(SI, LS);
    TI = [CA,CH;CV,CD];
%     imshow(TI);
%     disp(size(TI));
	for D=1:m*n
		x = mod(((alpha+x*(1-x))/(y*(1-y))),1);
		y = mod(((beta+y*(1-y))/(z*(1-z))),1);
		z = mod(((gamma+z*(1-z))/(x*(1-x))),1);
		xx = mod(round(x*10.^14),i)+1;
		yy = mod(round(y*10.^14),j)+1;
		zz = mod(round(z*10.^14),k)+1;
		if flag(xx,yy,zz)==1
			bitset(mask(1,D),1:8,bitget(uint8(TI(xx,yy,zz)),1:8));
			flag(xx,yy,zz)=0;
		end
	end
	T=1;
	for E=1:m
		for F=1:n
			SM(E,F)=mask(1,T);
			T=T+1;
		end
	end
	imwrite(uint8(SM), 'extracted.png')


