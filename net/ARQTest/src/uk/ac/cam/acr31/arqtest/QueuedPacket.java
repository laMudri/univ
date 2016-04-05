/**
 * 
 */
package uk.ac.cam.acr31.arqtest;

import java.net.DatagramPacket;
import java.net.InetAddress;

public class QueuedPacket {

	private int port;
	private InetAddress address;
	private byte[] data;
	private long sendTime;

	public QueuedPacket(DatagramPacket p, long sendTime) {
		super();
		this.port = p.getPort();
		this.address = p.getAddress();
		this.data = p.getData().clone();
		this.sendTime = sendTime;

	}

	public DatagramPacket toDatagram() {
		DatagramPacket result = new DatagramPacket(data, data.length);
		result.setPort(port);
		result.setAddress(address);
		return result;
	}

	public long getSendTime() {
		return sendTime;
	}
}