#!/bin/bash
#Formatting constants
F_RESET='\e[39;0m'
F_INFO='\e[1;93m[\e[94m \u2139 \e[93m]\e[0;96;3m '
F_CHECK='\e[1;93m[\e[92m \u2714 \e[93m]\e[0;96;3m '
F_CROSS='\e[1;93m[\e[31m \u2718 \e[93m]\e[0;96;3m '
#Path constants
BIN_URL='http://avellano.usal.es/~compii/'
BIN_INSTALL_PATH="$HOME/bin/"
BINARIES=( 'as6809' 'aslink' 'm6809-run' )
GEDIT_SPEC_URL="${BIN_URL}INSTALADOR/"
GEDIT_SPEC_PATH="$HOME/.local/share/gtksourceview-3.0/language-specs/"
GEDIT_SPEC='asm6809.lang'
#Function to check the actual Unix distribution
function checkSystem() {
	#Checks if lsb-release exists in order to verify the distribution.
	if [ -f '/etc/lsb-release' ]; then
		echo -e $F_CHECK'Tu ordenador es compatible con lsb-release.'$F_RESET
        	DISTRIBUCION=`lsb_release -si`
		#Checks if the distribution is Ubuntu.
        	if [ $DISTRIBUCION == 'Ubuntu' ]; then
			echo -e $F_CHECK'Tu ordenador es Ubuntu.'$F_RESET
			return 0
        	else
			echo -e $F_INFO' ATENCIÓN: No tienes una distribucion Ubuntu. Ejecuta el programa con el parámetro -f para forzar la instalación. Es posible que se produzcan errores durante la instalación.'$F_RESET
			return 2
        	fi
	else
		echo -e $F_CROSS' ERROR: Tu ordenador no es compatible con lsb-release. Saliendo del programa...'$F_RESET
		return 1
	fi
}
#Function to check if wget is available.
function hasWget() {
	#Check if wget is already installed.
	if hash wget 2>/dev/null; then
		echo -e $F_CHECK'El comando "wget" está instalado.'$F_RESET
		return 1
	else
		echo -e $F_INFO'El comando "wget" no está instalado. ¿Quieres instalarlo ahora?'$F_RESET
		OPTIONS="Sí No"
           	select opt in $OPTIONS; do
               		if [ "$opt" = "No" ]; then
                		echo -e $F_CROSS' ERROR: No se puede continuar sin la instrucción "wget". Saliendo del programa...'$F_RESET
                		return 0
                		break
               		elif [ "$opt" = "Sí" ]; then
                		echo 'Procediendo a la instalación...'
                		sudo apt-get install wget
                		if hash wget 2>/dev/null; then
                    			echo -e $F_CHECK'El comando "wget" se instaló correctamente.'$F_RESET
		            		return 1
		        	else
		            		echo -e $F_CROSS' ERROR: Se produjo un error durante la instalación. Saliendo del programa...'$F_RESET
		            		return 0
		        	fi
                		break
               		else
                		echo ' ERROR: Opción incorrecta. Teclee 1 ó 2 y a continuación pulse ENTER.'
				return 0
               		fi
           done
	fi
}
#Function to check the preconditions.
function preCheck(){
	checkSystem
	if [ $? -ne 0 ]; then
		exit 1
	else
		hasWget
		if [ $? -ne 1 ]; then
			exit 1
		fi
	fi
	return 0
}
#Function to check if a directory exists.
#Needs one argument, which is the path we want to check.
function ensureDir(){
	#Check existance. If it doesn't exist, we create it.
	if [ ! -d $1 ]; then
		mkdir -p $1
		#Check if it has been correctly created.
		if [ -d $1 ]; then
			echo -e $F_INFO"Se ha creado la carpeta $1."$F_RESET
			return 0
		else
			echo -e $F_CROSS" ERROR: No hay permisos suficientes para crear la carpeta $1."$F_RESET
			return 1
		fi
	fi
	#Check if we have writing permissions
	if [ ! -w $1 ]; then
		echo -e $F_CROSS" ERROR: No hay permisos de escritura en la carpeta $1."$F_RESET
		return 1
	fi
	return 0
}
#Function to install dependencies to run programs that are i386 on amd64.
function installi386Compat(){
	#Check if OS is 64bit
	if [ $HOSTTYPE == 'x86_64' ]; then
		sudo apt-get install libc6-i386
		echo -e $F_CHECK'Se han instalado las dependencias para programas i386 en amd64.'$F_RESET
	fi
	return 0
}
#Function to download and install the required files from URL
#Needs three arguments: the URL, the install path and the file name
function installFromURL(){
	if [ -f $2$3 ]; then
		echo -e $F_INFO"¡\"$3\" ya está instalado!"$F_RESET
		return 0
	fi
	wget -P $2 $1$3
	if [ ! -f $2$3 ]; then
		echo -e $F_CROSS" ERROR: No se ha podido descargar \"$3\"."$F_RESET
		return 1
	else
		echo -e $F_CHECK"\"$3\" se instaló correctamente."$F_RESET
		return 0
	fi
}
#Function that gives execution permissions
#Needs two arguments: file's path and name
function addExecution(){
	if [ -x $1$2 ]; then
		return 0
	fi
	chmod +x $1$2
	if [ ! -x $1$2 ]; then
		echo -e $F_CROSS"No se le han podido dar permisos de ejecución a \"$2\"."$F_RESET
		return 1	
	else
		echo -e $F_INFO"\"$2\" ha recibido permisos de ejecución."$F_RESET
		return 0
	fi
}
#Function to ensure if the path is already in the bashrc file
#Needs one argument: the path
function ensurePath(){
	if [[ :$PATH: == *:"$1":* ]]; then
		echo -e $F_INFO"\"$1\" ya está añadido al PATH."$F_RESET
		return 0	
	else
		echo -e "\n# Añadido $1 al PATH" >> "$HOME/.bashrc"
		echo "PATH=\$PATH:$1" >> "$HOME/.bashrc"
		return 0
	fi
}
#Function that downloads and installs the required files from http://avellano.usal.es/~compii/
function installBin(){
	ensureDir $BIN_INSTALL_PATH
	if [ $? -ne 0 ]; then
		exit 1
	fi
	installi386Compat
	for bin in ${BINARIES[@]} ; do
		installFromURL $BIN_URL $BIN_INSTALL_PATH $bin
		if [ $? -ne 0 ]; then
			exit 1
		fi
		addExecution $BIN_INSTALL_PATH $bin
		if [ $? -ne 0 ]; then
			exit 1
		fi
	done
	ensurePath $BIN_INSTALL_PATH
	if [ $? -ne 0 ]; then
		exit 1
	fi
	return 0	
}
#Function that installs the color template for gedit
function installLangSpec(){
	ensureDir $GEDIT_SPEC_PATH
	if [ $? -ne 0 ]; then
		exit 1
	fi
	installFromURL $GEDIT_SPEC_URL $GEDIT_SPEC_PATH $GEDIT_SPEC
	if [ $? -ne 0 ]; then
		exit 1
	fi
}
#Function to insert a pause prompt
function pause(){
   read -p "$*"
}
 
if [ "$1" != '-f' ]; then
	preCheck
else
	echo -e $F_INFO' ATENCION: Se va a forzar la instalación. Puede que se produzcan errores durante la misma. Asegúrate de que tu distribución es compatible.'$F_RESET
	pause 'Pulsa ENTER para continuar...'
fi
installBin
installLangSpec
