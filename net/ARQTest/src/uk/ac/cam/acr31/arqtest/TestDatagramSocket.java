/**
 * 
 */
package uk.ac.cam.acr31.arqtest;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.SocketException;
import java.net.SocketTimeoutException;
import java.util.LinkedList;
import java.util.Random;

public class TestDatagramSocket extends DatagramSocket {
	public static final boolean DEBUG = true;

	private SendingThread queue = new SendingThread();
	private Random random = new Random();
	private long propagationTimeMillis;
	private double lossProbability;

	private class SendingThread implements Runnable {
		private LinkedList<QueuedPacket> queue = new LinkedList<QueuedPacket>();
		private boolean running = false;

		public synchronized void enqueue(QueuedPacket q) {
			queue.add(q);
			if (!running) {
				new Thread(this).start();
			}
		}

		@Override
		public synchronized void run() {
			running = true;
			try {
				while (!queue.isEmpty()) {
					long time = System.currentTimeMillis();
					QueuedPacket p = queue.getFirst();
					long sendTime = p.getSendTime();
					if (sendTime <= time) {
						TestDatagramSocket.super.send(p.toDatagram());
						queue.remove(p);
					} else {
						this.wait(sendTime - time);
					}
				}
			} catch (InterruptedException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				running = false;
			}
		}
	}

	public TestDatagramSocket(double lossProbability, long propagationTimeMillis)
			throws SocketException {
		super();
		this.lossProbability = lossProbability;
		this.propagationTimeMillis = propagationTimeMillis;
	}

	public TestDatagramSocket(int port, double lossProbability,
			long propagationTimeMillis) throws SocketException {
		super(port);
		this.lossProbability = lossProbability;
		this.propagationTimeMillis = propagationTimeMillis;
	}

	@Override
	public void send(DatagramPacket p) throws IOException {
		if (random.nextDouble() > lossProbability) {
			long sendTime = System.currentTimeMillis() + propagationTimeMillis;
			queue.enqueue(new QueuedPacket(p, sendTime));
			if (DEBUG) {
				System.out.println(mesg(p, true));
			}
		} else {
			if (DEBUG) {
				System.out.println(mesg(p, true) + " PACKET LOST");
			}
		}
	}

	@Override
	public synchronized void receive(DatagramPacket p) throws IOException {
		try {
			super.receive(p);
			System.out.println(mesg(p, false));
		} catch (SocketTimeoutException e) {
			if (DEBUG) {
				System.out.println(mesg(null, false) + "TIMEOUT");
			}
			throw e;
		}
	}

	private String mesg(DatagramPacket p, boolean dir) {
		String d = dir ? "->" : "<-";
		if (p != null) {
			String r = this.getLocalAddress().getHostName() + ":"
					+ this.getLocalPort() + d + p.getAddress().getHostName()
					+ ":" + p.getPort()+"\t";
			byte[] data = p.getData();
			for (int i = 0; i < data.length && i < 10; ++i) {
				r += " " + (int) data[i];
			}
			return r;
		} else {
			return this.getLocalAddress().getHostName() + ":"
					+ this.getLocalPort() + d;
		}
	}

}