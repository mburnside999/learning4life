List<Account> clients = ClientDAO.getAllCurrentClients();
System.debug(clients);
//System.debug(ClientDAO.getClientById(clients[0].Id));
//System.debug(SessionDAO.getAllSessions());
System.debug(SessionDAO.getAllSessionsForAClient(clients[0].Id));
