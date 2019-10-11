# Infraestrutura de Bancos de Dados
> Laboratório de Inovação Tecnológica em Saúde - LAIS
> Núcleo Avançado de Inovação Tecnológica - NAVI

> **Versão 2018.01.22**

Os scripts contidos neste projeto tem por objetivo automatizar o uso dos bancos de dados pela equipe de Infraestrutura e Banco de Dados. Desta forma, abaixo estarão listados os scripts existentes e a forma como utilizá-los.

  
----------
## Scripts

	1. Create_DB
	2. AlterOwner
	3. ListAll
	4. bkp_allAlone


## Create_DB

### Geral

Este script deve ser utilizado para criar o usuário, senha e banco, bem como registrar essa nova entrada nos arquivos de configurações do PostgresSQL. 

Apenas o usuário POSTGRES pode executar esse script.

Ao instanciar o script será necessário 6 informações:

	- Nome do Solicitante
	- Nome do Sistema
	- Nome do Usuário
	- Nome do Banco
	- Senha do Usuário
	- IP do Servidor do Serviço

Os 2 primeiros itens serve para documentação, desta forma é importante que sejam devidamente informados para que se mantenha o controle dos bancos de dados existentes e quem são seus administradores.

Os itens 3, 4 e 5 são necessários para a criação do banco em si. Um **usuário do sistema** para o acesso ao banco, sua **senha de acesso** e o novo **banco** a ser criado.

Por fim será questionado o **IP do servidor** que manterá o sistema, **DEVE** ser informado o **IP** e sua **Máscara** no padrão **x.x.x.x/y**. Caso não exista ainda um servidor definido, basta informar durante o *prompt* a opção **n**.

Esta sequência de passos automatiza a criação do novo banco e usuário, bem como garante uma "documentação" mínima sobre o administrador e o sistema.

### Pré-Requisitos

Alterar o caminho da variável do PG_HBA manualmente para corresponder com a sua instância do PostgreSQL em uso.

