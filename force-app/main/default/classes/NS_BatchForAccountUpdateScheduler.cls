Global class NS_BatchForAccountUpdateScheduler  implements Schedulable  {
	global void execute(SchedulableContext ctx) {
        NS_BatchForAccountUpdate batchToTransfer = new NS_BatchForAccountUpdate();
        database.executebatch(batchToTransfer);
    }
}